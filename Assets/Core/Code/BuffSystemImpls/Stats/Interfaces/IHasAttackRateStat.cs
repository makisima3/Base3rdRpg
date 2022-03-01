using Core.Code.BuffSystem;
using Core.Code.Interfaces;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasAttackRateStat : IStats, IObservableStats<IHasAttackRateStat>
    {
        float AttackRate { get; set; }
        float BaseAttackRate { get; }
    }
}