using System;
using Core.Code.BuffSystem;
using UnityEngine.Events;

namespace Core.Code.Interfaces
{
    public interface IObservableStats<TStats>
        where TStats : class, IStats
    {
        UnityEvent<TStats> OnChanged { get; }
        void UpdateThis(Action<TStats> updateAction = null);
    }
}