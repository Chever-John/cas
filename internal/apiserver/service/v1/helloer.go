package v1

import "context"

type HelloerSrv interface {
	GetHello(ctx context.Context, name string) error
}

type HelloerService struct {
}

// static check, make sure HelloerService implements HelloerSrv interface.
var _ HelloerSrv = (*HelloerService)(nil)

func newHelloers(srv *service) *HelloerService {
	return &HelloerService{}
}

// GetHello returns a greeting for the named person.
func (s *HelloerService) GetHello(ctx context.Context, name string) error {
	return nil
}
