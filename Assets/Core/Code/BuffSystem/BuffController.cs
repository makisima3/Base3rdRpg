using System.Collections.Generic;
using Core.Code.BuffSystemImpls.Effects;
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
            var effect = GetComponentInChildren<IEffect<TStats, TBuff>>(true);
            //вот тут не нашел эффект 
            if(effect == null)
                return;
            
            effect.Activate(stats, buff);
        }
    }
}