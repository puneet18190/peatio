module Admin
  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user.admin?

      can :read, Order
      can :read, Trade
      can :read, Proof
      can :update, Proof
      can :manage, Document
      can :manage, Member
      can :manage, Ticket
      can :manage, IdDocument
      can :manage, TwoFactor

      can :menu, Deposit
      can :manage, ::Deposits::Bank
      can :manage, ::Deposits::Satoshi
      can :manage, ::Deposits::Ether
      can :manage, ::Deposits::Litecoin
      can :manage, ::Deposits::Dogecoin
      can :manage, ::Deposits::Dash
      can :manage, ::Deposits::Riecoin
      can :manage, ::Deposits::Peercoin
      can :manage, ::Deposits::Primecoin
      can :manage, ::Deposits::Florincoin

      can :menu, Withdraw
      can :manage, ::Withdraws::Bank
      can :manage, ::Withdraws::Satoshi
      can :manage, ::Withdraws::Litecoin
      can :manage, ::Withdraws::Dogecoin
      can :manage, ::Withdraws::Dash
      can :manage, ::Withdraws::Riecoin
      can :manage, ::Withdraws::Peercoin
      can :manage, ::Withdraws::Primecoin
      can :manage, ::Withdraws::Florincoin

    end
  end
end
