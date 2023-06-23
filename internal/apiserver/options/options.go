package options

import (
	genericoptions "github.com/Chever-John/Chever-Apiserver/internal/pkg/options"
	"github.com/Chever-John/Chever-Apiserver/pkg/log"
	cliflag "github.com/Chever-John/component-base/pkg/cli/flag"
)

// Options is the options for apiserver.
type Options struct {
	GenericServerRunOptions *genericoptions.ServerRunOptions `json:"server"   mapstructure:"server"`
	Log                     *log.Options                     `json:"log" mapstructure:"log"`
}

// NewOptions creates a new Options object with default params.
func NewOptions() *Options {
	o := Options{
		GenericServerRunOptions: genericoptions.NewServerRunOptions(),
	}

	return &o
}

// Flags returns flags for a specific ApiServer by section name.
func (o *Options) Flags() (fss cliflag.NamedFlagSets) {
	o.GenericServerRunOptions.AddFlags(fss.FlagSet("generic"))

	return fss
}
