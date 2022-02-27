using System;
using System.Collections;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Buffs;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Effects
{
    public class DamageBuffEffect : MonoBehaviour, IEffect
    {
        [SerializeField] private GameObject fireParticles;
        
        public void Activate()
        {
            fireParticles.SetActive(true);
        }

        public void Deactivate()
        {
            fireParticles.SetActive(false);
        }
    }
}