package apiserver

import (
	"github.com/Chever-John/Chever-Apiserver/internal/apiserver/config"
	"github.com/Chever-John/Chever-Apiserver/internal/apiserver/options"
	"github.com/Chever-John/Chever-Apiserver/pkg/app"
	"github.com/Chever-John/Chever-Apiserver/pkg/log"
)

const commandDesc = `This is Chever's apiserver.`

// NewApp creates an App object with default parameters.
func NewApp(basename string) *app.App {
	opts := options.NewOptions()
	application := app.NewApp("Chever's apiserver",
		basename,
		app.WithOptions(opts),
		app.WithDescription(commandDesc),
		app.WithDefaultValidArgs(),
		app.WithRunFunc(run(opts)),
	)

	return application
}

func run(opts *options.Options) app.RunFunc {
	return func(basename string) error {
		log.Init(opts.Log)
		defer log.Flush()

		cfg, err := config.CreateConfigFromOptions(opts)
		if err != nil {
			return err
		}

		return Run(cfg)
	}
}
