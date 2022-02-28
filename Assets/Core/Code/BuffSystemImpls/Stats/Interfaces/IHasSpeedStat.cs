using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasSpeedStat : IStats
    {
        float Speed { get; set; }
        float BaseSpeed { get; }
    }
}