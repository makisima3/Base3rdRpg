namespace Core.Code.BuffSystem
{
    public interface IBuff<in TStats>
    {
        void Apply(TStats stats);
        
        void Reset(TStats stats);
    }
}