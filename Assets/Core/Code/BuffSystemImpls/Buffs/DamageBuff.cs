using System;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Buffs
{
    [Serializable]
    public class DamageBuff : IBuff<IHasDamageStat>
    {
        [SerializeField] private float duration = 5f;
        [SerializeField] private float multiplier = 1.5f;

        public float Duration => duration;

        public void Apply(IHasDamageStat stats)
        {
            stats.Damage += stats.BaseDamage * multiplier;
        }

        public void Reset(IHasDamageStat stats)
        {
            stats.Damage -= stats.BaseDamage * multiplier;
        }
    }
}