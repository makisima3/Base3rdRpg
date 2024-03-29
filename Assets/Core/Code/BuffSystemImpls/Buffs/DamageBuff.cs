﻿using System;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Buffs
{
    [Serializable]
    public class DamageBuff : IBuff<IHasDamageStat>, IBuff<IStats>
    {
        [SerializeField] private float duration = 5f;
        [SerializeField] private float multiplier = 1.5f;

        public DurationType DurationType => DurationType.Common;
        public float Duration => duration;

        public void Apply(IStats stats) => Apply(stats as IHasDamageStat);

        public void Reset(IStats stats) => Reset(stats as IHasDamageStat);
        
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