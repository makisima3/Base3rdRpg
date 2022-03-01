using System;
using System.Collections;
using System.Collections.Generic;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.EnemiesLogic;
using Core.Code.Models;
using Core.Code.PlayerLogic.States;
using Core.Code.Utils;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

namespace Core.Code.PlayerLogic
{
    [RequireComponent(typeof(Collider))]
    public class PlayerAttackController : MonoBehaviour
    {
        [SerializeField] private PlayerStateMachine playerStateMachine;
        [SerializeField] private PlayerMovementController movementController;
        [SerializeField] private PlayerStats playerStats;

        private List<ITarget> _targetsInAttackRange;

        public void Init()
        {
            _targetsInAttackRange = new List<ITarget>();
        }

        public void TryStartAttack()
        {
            if (_targetsInAttackRange.Count > 0)
            {
                playerStateMachine.CurrentStateType = PlayerStateMachine.States.AttackNormal;
            }
        }
        
        public void Attack()
        {
            foreach (var target in _targetsInAttackRange)
            {
                var isCritical = ChancesUtils.CheckChance(playerStats.CriticalChance);

                var damageAmount = isCritical
                    ? playerStats.Damage * playerStats.CriticalDamageMultiplier
                    : playerStats.Damage;

                var damage = new Damage()
                {
                    Amount = damageAmount,
                    IsCritical = isCritical
                };

                target.TakeDamage(damage);
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (!other.TryGetComponent<ITarget>(out var target)) 
                return;
            
            _targetsInAttackRange.Add(target);
        }

        private void OnTriggerExit(Collider other)
        {
            if (!other.TryGetComponent<ITarget>(out var target)) 
                return;
            
            _targetsInAttackRange.Remove(target);

            if (_targetsInAttackRange.Count <= 0)
            {
                playerStateMachine.CurrentStateType = PlayerStateMachine.States.Idle;
            }
        }
    }
}