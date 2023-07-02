package apiserver

import (
	"github.com/Chever-John/cas/pkg/log"
	"google.golang.org/grpc"
	"net"
)

type grpcApiServer struct {
	*grpc.Server
	address string
}

func (s *grpcApiServer) Run() {
	listen, err := net.Listen("tcp", s.address)
	if err != nil {
		log.Fatalf("failed to listen: %s", err.Error())
	}

	go func() {
		if err := s.Serve(listen); err != nil {
			log.Fatalf("failed to start grpc server: %s", err.Error())
		}
	}()

	log.Infof("start grpc server at %s", s.address)
}

func (s *grpcApiServer) Close() {
	s.GracefulStop()
	log.Infof("GRPC server on %s stopped", s.address)
}
