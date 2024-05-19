package users

type UserStore interface {
	CreateUser()
}

type UserService interface {
	SignUp()
}
