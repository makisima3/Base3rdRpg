using Core.Code.BuffSystemImpls.Stats.Interfaces;
using UnityEngine;
using UnityEngine.Serialization;

namespace Core.Code.BuffSystemImpls.Stats
{
    public class PlayerStats : MonoBehaviour, IHasDamageStat, IHasSpeedStat, IHasAttackRateStat, IHasCriticalDamageStat,
        IHasCriticalChanceStat
    {
        [SerializeField] private float baseDamage;
        [SerializeField, Tooltip("Attack count in second")] private float baseAttackRate;
        [SerializeField] private float baseSpeed;
        [SerializeField, Range(1f, float.MaxValue)] private float baseCriticalDamageMultipler;
        [SerializeField, Range(0f, 1f)] private float baseCriticalChance;

        public float BaseDamage => baseDamage;
        public float BaseAttackRate => baseAttackRate;
        public float BaseSpeed => baseSpeed;
        public float BaseCriticalDamageMultipler => baseCriticalDamageMultipler;
        public float BaseCriticalChance => baseCriticalChance;

        public float Damage { get; set; }
        public float AttackRate { get; set; }
        public float Speed { get; set; }
        public float CriticalDamageMultipler { get; set; }
        public float CriticalChance { get; set; }

        public void Initialize()
        {
            Damage = BaseDamage;
            AttackRate = BaseAttackRate;
            Speed = BaseSpeed;
            CriticalChance = BaseCriticalChance;
            CriticalDamageMultipler = BaseCriticalDamageMultipler;
        }
    }
}