package apiserver

import (
	"github.com/Chever-John/Chever-Apiserver/internal/apiserver/options"
	"github.com/Chever-John/Chever-Apiserver/pkg/app"
)

const commandDesc = `This is Chever's apiserver.`

// NewApp creates an App object with default parameters.
func NewApp(basename string) *app.App {
	opts := options.NewOptions()
	application := app.NewApp("Chever's apiserver",
		basename,
		app.WithOptions(opts),
	)

	return application
}
