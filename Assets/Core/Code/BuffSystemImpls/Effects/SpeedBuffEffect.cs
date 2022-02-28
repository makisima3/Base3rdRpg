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
    public class SpeedBuffEffect : MonoBehaviour, IEffect<SpeedBuff>
    {
        [SerializeField] private GameObject particles;

        public List<SpeedBuff> ActiveBuffs { get; private set; }


        public void Activate(SpeedBuff buff)
        {
            ActiveBuffs ??= new List<SpeedBuff>();

            ActiveBuffs.Add(buff);

            particles.SetActive(true);
        }

        public void Deactivate(SpeedBuff buff)
        {
            ActiveBuffs.Remove(buff);

            if (ActiveBuffs.Count <= 0)
                particles.SetActive(false);
        }
    }
}