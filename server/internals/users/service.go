package users

type Service struct {
	store UserStore
}

func NewService(store UserStore) *Service {
	return &Service{
		store,
	}
}

func (s *Service) SignUp() {

}
