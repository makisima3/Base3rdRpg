using System;
using System.Collections;
using System.Collections.Generic;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Buffs;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;
using UnityEngine.Serialization;

namespace Core.Code.BuffSystemImpls.Effects
{
    public class CriticalDamageBuffEffect : MonoBehaviour, IEffect<CriticalDamageBuff>
    {
        [SerializeField] private GameObject particles;

        public List<CriticalDamageBuff> ActiveBuffs { get; private set; }

        public void Activate(CriticalDamageBuff buff)
        {
            ActiveBuffs ??= new List<CriticalDamageBuff>();

            ActiveBuffs.Add(buff);
            
            particles.SetActive(true);
        }

        public void Deactivate(CriticalDamageBuff buff)
        {
            ActiveBuffs.Remove(buff);

            if (ActiveBuffs.Count <= 0)
            particles.SetActive(false);
        }
    }
}