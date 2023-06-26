package v1

import "context"

type HelloerSrv interface {
	GetHello(ctx context.Context, name string) error
}

type helloerService struct {
}

// static check, make sure helloerService implements HelloerSrv interface.
var _ HelloerSrv = (*helloerService)(nil)

func newHelloers(srv *service) *helloerService {
	return &helloerService{}
}

// GetHello returns a greeting for the named person.
func (s *helloerService) GetHello(ctx context.Context, name string)  error
	return nil
}
