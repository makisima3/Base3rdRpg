using System;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Buffs
{
    [Serializable]
    public class AttackRateBuff : IBuff<IHasAttackRateStat>, IBuff<IStats>
    {
        [SerializeField] private float duration = 5f;
        [SerializeField] private float multiplier = 1.5f;

        public DurationType DurationType => DurationType.Common;
        public float Duration => duration;
        public void Apply(IStats stats) => Apply(stats as IHasAttackRateStat);

        public void Reset(IStats stats) => Reset(stats as IHasAttackRateStat);

        public void Apply(IHasAttackRateStat stats)
        {
            stats.AttackRate += stats.BaseAttackRate * multiplier;
        }

        public void Reset(IHasAttackRateStat stats)
        {
            stats.AttackRate -= stats.BaseAttackRate * multiplier;
        }
    }
}