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
    public class AttackRateBuffEffect : MonoBehaviour, IEffect<AttackRateBuff>
    {
        [SerializeField] private GameObject particles;

        public List<AttackRateBuff> ActiveBuffs { get; private set; }

        public void Activate(AttackRateBuff buff)
        {
            ActiveBuffs ??= new List<AttackRateBuff>();

            ActiveBuffs.Add(buff);
            
            particles.SetActive(true);
        }

        public void Deactivate(AttackRateBuff buff)
        {
            ActiveBuffs.Remove(buff);

            if (ActiveBuffs.Count <= 0)
            particles.SetActive(false);
        }
    }
}