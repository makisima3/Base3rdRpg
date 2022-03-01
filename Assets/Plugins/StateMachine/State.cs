using System;
using UnityEngine;

namespace Plugins.StateMachine
{
    public abstract class State<TState> : MonoBehaviour
        where TState : Enum
    {
        public abstract TState Type { get; }
        
        public StateMachine<TState> StateMachine { get; set; }

        public abstract void OnEnter(TState previousState);
        
        public abstract void OnExit(TState nextState);
        
        public abstract void Loop();
    }
}