using System;
using System.Collections;
using System.Collections.Generic;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.EnemiesLogic;
using UnityEngine;
using UnityEngine.Serialization;

namespace Core.Code.PlayerLogic
{
    [RequireComponent(typeof(Collider))]
    
    public class PlayerAttackController : MonoBehaviour
    {
        [SerializeField] private PlayerMovementController movementController;
        [SerializeField] private PlayerStats playerStats;
        
        private Coroutine attackCorotine;
        private List<ITarget> targetsInAttackRange;

        public void Init()
        {
            targetsInAttackRange = new List<ITarget>();
        }

        private void Update()
        {
            if (movementController.IsMoving)
            {
                if (attackCorotine != null)
                {
                    StopCoroutine(attackCorotine);
                    attackCorotine = null;
                }
            }
        }

        private IEnumerator AttackCorotine()
        {
            while (true)
            {
                foreach (var target in targetsInAttackRange)
                {
                    target.TakeDamage(playerStats.Damage);
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
                    if(!movementController.IsMoving)
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
                    StopCoroutine(attackCorotine);

                    attackCorotine = null;
                }
                
                targetsInAttackRange.Remove(target);
            }
        }
    }
}