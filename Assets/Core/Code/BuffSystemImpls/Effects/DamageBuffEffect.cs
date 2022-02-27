using System;
using System.Collections;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Buffs;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Effects
{
    public class DamageBuffEffect : MonoBehaviour, IEffect<IHasDamageStat, DamageBuff>
    {
        [SerializeField] private GameObject fireParticles;
        
        public void Activate(IHasDamageStat stats, DamageBuff buff)
        {
            fireParticles.SetActive(true);
            StartCoroutine(Delayer(buff.Duration, () => Deactivate(stats, buff)));
        }

        private void Deactivate(IHasDamageStat hasDamageStat, DamageBuff damageBuff)
        {
            fireParticles.SetActive(false);
            damageBuff.Reset(hasDamageStat);
        }
        
        private IEnumerator Delayer(float delay, Action action)
        {
            yield return new WaitForSeconds(delay);
            
            action?.Invoke();
        }
    }
}