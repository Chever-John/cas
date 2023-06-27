package options

import (
	genericoptions "github.com/Chever-John/Chever-Apiserver/internal/pkg/options"
	"github.com/Chever-John/Chever-Apiserver/pkg/log"
	cliflag "github.com/Chever-John/component-base/pkg/cli/flag"
)

// Options is the options for apiserver.
type Options struct {
	GenericServerRunOptions *genericoptions.ServerRunOptions       `json:"server"   mapstructure:"server"`
	Log                     *log.Options                           `json:"log" mapstructure:"log"`
	FeatureOptions          *genericoptions.FeatureOptions         `json:"feature"  mapstructure:"feature"`
	SecureServing           *genericoptions.SecureServingOptions   `json:"secure"   mapstructure:"secure"`
	InsecureServing         *genericoptions.InsecureServingOptions `json:"insecure" mapstructure:"insecure"`
	GRPCOptions             *genericoptions.GRPCOptions            `json:"grpc"     mapstructure:"grpc"`
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
