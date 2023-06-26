package apiserver

import "github.com/Chever-John/Chever-Apiserver/internal/apiserver/config"

// Run runs the specified APIServer. This should never exit.
func Run(cfg *config.Config) error {
	server, err := createApiServer(cfg)
	if err != nil {
		return err
	}

	return server.PrepareRun().Run()
}
