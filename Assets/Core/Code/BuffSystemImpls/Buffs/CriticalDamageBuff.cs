using System;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Buffs
{
    [Serializable]
    public class CriticalDamageBuff : IBuff<IHasCriticalDamageStat>, IBuff<IStats>
    {
        [SerializeField] private float duration = 5f;
        [SerializeField] private float additionalCriticalDamage = 0.3f;

        public DurationType DurationType => DurationType.Common;
        public float Duration => duration;
        
        public void Apply(IStats stats) => Apply(stats as IHasCriticalDamageStat);

        public void Reset(IStats stats) => Reset(stats as IHasCriticalDamageStat);
        
        public void Apply(IHasCriticalDamageStat stats)
        {
            stats.CriticalDamageMultipler += additionalCriticalDamage;
        }

        public void Reset(IHasCriticalDamageStat stats)
        {
            stats.CriticalDamageMultipler += additionalCriticalDamage;
        }
    }
}