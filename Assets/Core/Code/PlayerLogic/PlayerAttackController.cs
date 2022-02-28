using System;
using System.Collections;
using System.Collections.Generic;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.EnemiesLogic;
using Core.Code.Utils;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

namespace Core.Code.PlayerLogic
{
    [RequireComponent(typeof(Collider))]
    
    public class PlayerAttackController : MonoBehaviour
    {
        [SerializeField] private PlayerMovementController movementController;
        [SerializeField] private PlayerStats playerStats;
        
        private Coroutine attackCorotine;
        private List<ITarget> targetsInAttackRange;

        private bool _isAtatck;
        
        public void Init()
        {
            targetsInAttackRange = new List<ITarget>();
        }


        private IEnumerator AttackCorotine()
        {
            while (_isAtatck)
            {
                if (!movementController.IsMoving)
                {
                    foreach (var target in targetsInAttackRange)
                    {
                        var isCritical = ChancesUtils.CheckChance(playerStats.CriticalChance);

                        var damage = isCritical
                            ? playerStats.Damage * playerStats.CriticalDamageMultipler
                            : playerStats.Damage;

                            target.TakeDamage(damage, isCritical);
                    }
                }

                yield return new WaitForSeconds(1 / playerStats.AttackRate);
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.TryGetComponent<ITarget>(out var target))
            {
                targetsInAttackRange.Add(target);

                if (targetsInAttackRange.Count == 1)
                {
                    _isAtatck = true;

                    if (attackCorotine != null)
                    {
                        StopCoroutine(attackCorotine);

                        attackCorotine = null;
                    }
                    
                    attackCorotine = StartCoroutine(AttackCorotine());
                }
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.TryGetComponent<ITarget>(out var target))
            {
                if (targetsInAttackRange.Count - 1 <= 0)
                {
                    _isAtatck = false;

                    if (attackCorotine != null)
                    {
                        StopCoroutine(attackCorotine);

                        attackCorotine = null;
                    }
                }
                
                targetsInAttackRange.Remove(target);
            }
        }
    }
}