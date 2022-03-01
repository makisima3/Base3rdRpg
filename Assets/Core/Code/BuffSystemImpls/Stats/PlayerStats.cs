using System;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;
using UnityEngine.Events;

namespace Core.Code.BuffSystemImpls.Stats
{
    public class PlayerStats : MonoBehaviour, IHasDamageStat, IHasSpeedStat, IHasAttackRateStat, IHasCriticalDamageStat,
        IHasCriticalChanceStat
    {
        [SerializeField] private float baseDamage;
        [SerializeField, Tooltip("Attack per second")] private float baseAttackRate;
        [SerializeField] private float baseSpeed;
        [SerializeField, Range(1f, float.MaxValue)] private float baseCriticalDamageMultiplier;
        [SerializeField, Range(0f, 1f)] private float baseCriticalChance;
        [SerializeField] private UnityEvent<IHasAttackRateStat> onChanged;

        public float BaseDamage => baseDamage;
        public float BaseAttackRate => baseAttackRate;
        public float BaseSpeed => baseSpeed;
        public float BaseCriticalDamageMultiplier => baseCriticalDamageMultiplier;
        public float BaseCriticalChance => baseCriticalChance;

        public float Damage { get; set; }
        public float AttackRate { get; set; }
        public float Speed { get; set; }
        public float CriticalDamageMultiplier { get; set; }
        public float CriticalChance { get; set; }

        public UnityEvent<IHasAttackRateStat> OnChanged => onChanged;

        public void Initialize()
        {
            Damage = BaseDamage;
            AttackRate = BaseAttackRate;
            Speed = BaseSpeed;
            CriticalChance = BaseCriticalChance;
            CriticalDamageMultiplier = BaseCriticalDamageMultiplier;
        }

        public void UpdateThis(Action<IHasAttackRateStat> updateAction = null)
        {
            updateAction?.Invoke(this);
            OnChanged.Invoke(this);
        }
    }
}