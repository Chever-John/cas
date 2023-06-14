package app

import (
	cliflag "github.com/Chever-John/component-base/pkg/cli/flag"
)

// CliOptions abstracts configuration options for reading parameters from the
// command line.
type CliOptions interface {
	Flags() (fss cliflag.NamedFlagSets)
	Validate() []error
}

// ConfigurableOptions abstracts configuration options for reading parameters
// from a configuration file.
type ConfigurableOptions interface {
	// ApplyFlags parsing parameters from the command line or configuration file
	// to the options instance.
	ApplyFlags() []error
}

// CompleteableOptions abstracts options which can be completed.
type CompleteableOptions interface {
	Complete() error
}

// PrintableOptions abstracts options which can be printed.
type PrintableOptions interface {
	String() string
}
