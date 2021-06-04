import Foundation

final class CallStation {
    private var userList: [User] = []
    private var callList: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return userList
    }
    
    func add(user: User) {
        guard !userList.contains(user) else { return }
        userList.append(user)
    }
    
    func remove(user: User) {
        userList = userList.filter { $0 != user }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case .start(from: let caller, to: let callee):
            return executeStart(from: caller, to: callee)
        case .answer(from: let incomingUser):
            return executeAnswer(from: incomingUser)
        case .end(from: let user):
            return executeEnd(from: user)
        }
    }
    
    func calls() -> [Call] {
        callList
    }
    
    func calls(user: User) -> [Call] {
        callList.filter { $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id}
    }
    
    func call(id: CallID) -> Call? {
        callList.filter { $0.id == id }.first
    }
    
    func currentCall(user: User) -> Call? {
        calls(user: user).filter { $0.status == .calling || $0.status == .talk }.first
    }
    
    // MARK: - Supporting functions
    private func executeStart(from caller: User, to callee: User) -> CallID? {
        if !userList.contains(caller) && !userList.contains(callee) { return nil } //||?
        
        //Creating sure callID is unique
        var callID = CallID()
        while calls().contains(where: { element in element.id == callID }) {
            callID = CallID()
        }
        
        var callStatus: CallStatus
        if !userList.contains(caller) || !userList.contains(callee) {
            callStatus = .ended(reason: .error)
        } else if calls(user: callee).filter({ $0.status == .talk || $0.status == .calling }).count > 0 {
            callStatus = .ended(reason: .userBusy)
        } else {
            callStatus = .calling
        }

        callList.append(Call(id: callID, incomingUser: callee, outgoingUser: caller, status: callStatus))
        
        return callID
    }
    
    private func executeAnswer(from incomingUser: User) -> CallID? {
        guard let call = callList.filter({ $0.incomingUser == incomingUser && $0.status == .calling }).first else { return nil }
        
        var someoneCrashed = false
        for user in [call.incomingUser, call.outgoingUser] {
            if !userList.contains(user) {
                abortAllCalls(for: user)
                someoneCrashed = true
            }
        }
        guard !someoneCrashed else { return nil }
        
        changeStatus(for: call, to: .talk)
        return call.id
    }
    
    private func abortAllCalls(for user: User) {
        for brokenCall in calls(user: user) {
            changeStatus(for: brokenCall, to: .ended(reason: .error))
        }
    }
    
    private func executeEnd(from user: User) -> CallID? {
        guard let call = calls(user: user).filter({ $0.status == .talk ||  $0.status == .calling }).first else { return nil }
    
        let endReason: CallEndReason = call.status == .talk ? .end : .cancel
        changeStatus(for: call, to: .ended(reason: endReason))
        return call.id
    }
    
    private func changeStatus(for call: Call, to status: CallStatus) {
        callList = callList.filter { $0.id != call.id }
        callList.append(Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: status))
    }
}
