package v1

type Service interface {
	Helloers() HelloerSrv
}

type service struct {
}

// NewService returns Service interface.
func NewService() Service {
	return &service{}
}

func (s *service) Helloers() HelloerSrv {
	return newHelloers(s)
}
