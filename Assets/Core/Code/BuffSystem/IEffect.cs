using System.Collections.Generic;

namespace Core.Code.BuffSystem
{
    public interface IEffect<TBuff>
        where TBuff : IBuff<IStats>
    {
        List<TBuff> ActiveBuffs { get; }

        void Activate(TBuff buff);
        void Deactivate(TBuff buff);
    }
}