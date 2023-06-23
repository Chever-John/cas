package config

import "github.com/Chever-John/Chever-Apiserver/internal/apiserver/options"

// Config is the running configuration structure of the IAM pump service.
type Config struct {
	*options.Options
}

// CreateConfigFromOptions creates a running configuration instance based
// on a given IAM pump command line or configuration file option.
func CreateConfigFromOptions(opts *options.Options) (*Config, error) {
	return &Config{opts}, nil
}
