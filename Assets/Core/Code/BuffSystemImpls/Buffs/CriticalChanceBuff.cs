using System;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Buffs
{
    [Serializable]
    public class CriticalChanceBuff : IBuff<IHasCriticalChanceStat>, IBuff<IStats>
    {
        [SerializeField] private float duration = 5f;
        [SerializeField,Range(0f,1f)] private float multiplier = 0.5f;

        public DurationType DurationType => DurationType.Common;
        public float Duration => duration;
        
        public void Apply(IStats stats) => Apply(stats as IHasCriticalChanceStat);

        public void Reset(IStats stats) => Reset(stats as IHasCriticalChanceStat);
        
        public void Apply(IHasCriticalChanceStat stats)
        {
            stats.CriticalChance += stats.BaseCriticalChance * multiplier;
        }

        public void Reset(IHasCriticalChanceStat stats)
        {
            stats.CriticalChance -= stats.BaseCriticalChance * multiplier;
        }
    }
}