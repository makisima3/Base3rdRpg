using System;
using System.Collections;
using UnityEngine;

namespace Core.Code.BuffSystem
{
    public abstract class BuffController<TStats> : MonoBehaviour
        where TStats : IStats
    {
        [SerializeField] private TStats stats;
        
        public virtual void Initialize()
        {
            stats.Initialize();
        }

        public void Apply<TBuff>(TBuff buff) 
            where TBuff : IBuff<TStats>
        {
            buff.Apply(stats);
            
            var effect = GetComponentInChildren<IEffect>(true);
            effect?.Activate();

            Action deactivateAction = () =>
            {
                buff.Reset(stats);
                effect?.Deactivate();
            };

            switch (buff.DurationType)
            {
                case DurationType.Common:
                    DelayRun(buff.Duration, deactivateAction);
                    break;
                case DurationType.OneTime:
                    deactivateAction.Invoke();
                    break;
                case DurationType.Endless:
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        private void DelayRun(float delay, Action action)
        {
            StartCoroutine(Delayer(delay, action));
        }
        
        private IEnumerator Delayer(float delay, Action action)
        {
            yield return new WaitForSeconds(delay);
            action?.Invoke();
        }
    }
}