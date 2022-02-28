using System;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Buffs
{
    [Serializable]
    public class SpeedBuff : IBuff<IHasSpeedStat>, IBuff<IStats>
    {
        [SerializeField] private float duration = 5f;
        [SerializeField] private float bonusSpeed = 1.5f;

        public DurationType DurationType => DurationType.Common;
        public float Duration => duration;
        public void Apply(IStats stats) => Apply(stats as IHasSpeedStat);

        public void Reset(IStats stats) => Reset(stats as IHasSpeedStat);

        public void Apply(IHasSpeedStat stats)
        {
            stats.Speed += bonusSpeed;
        }

        public void Reset(IHasSpeedStat stats)
        {
            stats.Speed -= bonusSpeed;
        }
    }
}