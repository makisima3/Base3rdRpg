using UnityEngine;

namespace Core.Code.BuffSystemImpls.Stats
{
    public class PlayerStats: MonoBehaviour, IHasDamageStat
    {
        
        [field:SerializeField] public float BaseDamage { get; set; }
        [field:SerializeField, Tooltip("Attack count in second")] public float BaseAttackRate { get; set; }
        [field: SerializeField] public float BaseSpeed { get; set; }
        
        public float Damage { get; set; }
        public float AttackRate { get; set; }
        public float Speed { get; set; }
        
        public void Initialize()
        {
            Damage = BaseDamage;
            AttackRate = BaseAttackRate;
            Speed = BaseSpeed;
        }
    }
}