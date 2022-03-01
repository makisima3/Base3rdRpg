using System;
using System.Collections.Generic;
using UnityEngine;

namespace Plugins.StateMachine
{
    public abstract class StateMachine<TStateType> : MonoBehaviour
        where TStateType : Enum
    {
        [SerializeField] protected TStateType firstStateType;
        [SerializeField] private TStateType currentStateType;

        private Dictionary<TStateType, State<TStateType>> _states;

        public State<TStateType> CurrentState { get; private set; }

        public bool IsActive { get; set; }

        public TStateType CurrentStateType
        {
            get => currentStateType;

            set
            {
                if(!IsActive)
                    return;

                if(CurrentStateType.Equals(value))
                    return;
                
                if (CurrentState != null)
                    CurrentState.OnExit(value);
                
                CurrentState = _states[value];
                CurrentState.OnEnter(currentStateType);

                currentStateType = value;
            }
        }


        protected virtual void Awake()
        {
            IsActive = true;
            _states = new Dictionary<TStateType, State<TStateType>>();

            foreach (var state in GetComponents<State<TStateType>>())
            {
                AddState(state.Type, state);
            }
        }

        protected void AddState(TStateType stateType, State<TStateType> state)
        {
            _states.Add(stateType, state);
            state.StateMachine = this;
        }

        private void Update()
        {
            CurrentState.Loop();
        }
    }
}