using System;
using System.Collections;
using System.Collections.Generic;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Buffs;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.Effects
{
    public class DamageBuffEffect : MonoBehaviour, IEffect<DamageBuff>
    {
        [SerializeField] private GameObject fireParticles;


        public List<DamageBuff> ActiveBuffs { get; private set; }

        public void Activate(DamageBuff buff)
        {
            ActiveBuffs ??= new List<DamageBuff>();

            ActiveBuffs.Add(buff);
            
            fireParticles.SetActive(true);
        }

        public void Deactivate(DamageBuff buff)
        {
            ActiveBuffs.Remove(buff);

            if (ActiveBuffs.Count <= 0)
            fireParticles.SetActive(false);
        }
    }
}