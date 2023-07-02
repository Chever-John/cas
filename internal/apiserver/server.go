package apiserver

import (
	"github.com/Chever-John/cas/internal/apiserver/config"
	genericoptions "github.com/Chever-John/cas/internal/pkg/options"
	genericapiserver "github.com/Chever-John/cas/internal/pkg/server"
	"github.com/Chever-John/cas/pkg/log"
	"github.com/Chever-John/cas/pkg/shutdown"
	"github.com/Chever-John/cas/pkg/shutdown/shutdownmanagers/posixsignal"
)

type apiServer struct {
	gs               *shutdown.GracefulShutdown
	genericApiServer *genericapiserver.GenericApiServer
}

type preparedApiServer struct {
	*apiServer
}

// ExtraConfig defines extra configuration for the iam-apiserver.
type ExtraConfig struct {
	Addr       string
	MaxMsgSize int
	ServerCert genericoptions.GeneratableKeyCert
	// etcdOptions      *genericoptions.EtcdOptions
}

func createApiServer(cfg *config.Config) (*apiServer, error) {
	gs := shutdown.New()
	gs.AddShutdownManager(posixsignal.NewPosixSignalManager())

	genericConfig, err := buildGenericConfig(cfg)
	if err != nil {
		return nil, err
	}

	//extraConfig, err := buildExtraConfig(cfg)
	//if err != nil {
	//	return nil, err
	//}

	genericServer, err := genericConfig.Complete().New()
	if err != nil {
		return nil, err
	}
	//extraServer, err := extraConfig.complete().New()
	//if err != nil {
	//	return nil, err
	//}

	server := &apiServer{
		gs:               gs,
		genericApiServer: genericServer,
		// gRPCApiServer:    extraServer,
	}

	return server, nil
}

func (s *apiServer) PrepareRun() preparedApiServer {
	initRouter(s.genericApiServer.Engine)

	s.gs.AddShutdownCallback(shutdown.ShutdownFunc(func(string) error {
		// s.gRPCApiServer.Close()
		s.genericApiServer.Close()

		return nil
	}))

	return preparedApiServer{s}
}

func (s preparedApiServer) Run() error {
	// go s.gRPCApiServer.Run()

	// start shutdown managers
	if err := s.gs.Start(); err != nil {
		log.Fatalf("failed to start shutdown managers: %s", err.Error())
	}

	return s.genericApiServer.Run()
}

func buildGenericConfig(cfg *config.Config) (genericConfig *genericapiserver.Config, lastErr error) {
	genericConfig = genericapiserver.NewConfig()
	if lastErr = cfg.GenericServerRunOptions.ApplyTo(genericConfig); lastErr != nil {
		return
	}

	if lastErr = cfg.FeatureOptions.ApplyTo(genericConfig); lastErr != nil {
		return
	}

	if lastErr = cfg.SecureServing.ApplyTo(genericConfig); lastErr != nil {
		return
	}

	if lastErr = cfg.InsecureServing.ApplyTo(genericConfig); lastErr != nil {
		return
	}

	return
}
