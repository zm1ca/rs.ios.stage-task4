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
            if !userList.contains(caller) && !userList.contains(callee) {
                return nil
            }
            
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
        case .answer(from: let incomingUser):
            guard let call = callList.filter({ $0.incomingUser == incomingUser && $0.status == .calling }).first else { return nil }
            
            if !userList.contains(call.incomingUser) {
                for brokenCall in calls(user: call.incomingUser) {
                    callList = callList.filter { $0.id != brokenCall.id }
                    callList.append(Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error)))
                    return nil
                }
            }
            
            //Make it a distinct function
            if !userList.contains(call.outgoingUser) {
                for brokenCall in calls(user: call.outgoingUser) {
                    callList = callList.filter { $0.id != brokenCall.id }
                    callList.append(Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error)))
                    return nil
                }
            }
            
            callList = callList.filter { $0.id != call.id }
            callList.append(Call(id: call.id,
                                 incomingUser: call.incomingUser,
                                 outgoingUser: call.outgoingUser,
                                 status: .talk))
            
            return call.id
        case .end(from: let user):
            guard let call = calls(user: user).filter({ $0.status == .talk ||  $0.status == .calling }).first else { return nil }
            
            //Code duplication
            callList = callList.filter { $0.id != call.id }
            
            let endReason: CallEndReason = call.status == .talk ? .end : .cancel
            
            callList.append(Call(id: call.id,
                                 incomingUser: call.incomingUser,
                                 outgoingUser: call.outgoingUser,
                                 status: .ended(reason: endReason)))
            
            return call.id
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
        callList.filter { ($0.incomingUser.id == user.id || $0.outgoingUser.id == user.id) && ($0.status == .calling || $0.status == .talk)}.first
    }
}
