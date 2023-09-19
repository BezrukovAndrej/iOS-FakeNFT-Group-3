import Foundation
import ProgressHUD

protocol ProfileViewModelProtocol {
    var userProfile: UserProfile? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void)
    
    func viewDidLoad()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfile?
    
    private let profileService: ProfileService
    
    init(service: ProfileService) {
        self.profileService = service
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: NSNotification.Name("profileUpdated"), object: nil)
    }
    
    @objc
    private func profileUpdated() {
        fetchUserProfile()
    }
    
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void) {
        $userProfile.observe(handler)
    }
    
    func viewDidLoad() {
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        ProgressHUD.show(NSLocalizedString("Loading", comment: ""))
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                self.userProfile = userProfile
            case .failure(let error):
                //ToDo: - Уведомление об ошибке
                print(error)
            }
            ProgressHUD.dismiss()
        }
    }
}
