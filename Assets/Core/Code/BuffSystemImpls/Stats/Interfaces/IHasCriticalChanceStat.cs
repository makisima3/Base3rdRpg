using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasCriticalChanceStat : IStats
    {
        float CriticalChance { get; set; }
        float BaseCriticalChance { get; }
    }
}