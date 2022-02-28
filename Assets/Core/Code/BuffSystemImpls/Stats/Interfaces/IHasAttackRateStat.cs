using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasAttackRateStat : IStats
    {
        float AttackRate { get; set; }
        float BaseAttackRate { get; }
    }
}