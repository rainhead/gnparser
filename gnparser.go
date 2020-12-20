package gnparser

import (
	"github.com/gnames/gnlib/domain/entity/gn"
	"github.com/gnames/gnparser/config"

	"github.com/gnames/gnparser/entity/input"
	"github.com/gnames/gnparser/entity/output"
	"github.com/gnames/gnparser/grammar"
)

// GNparser is responsible for parsing operations.
type gnparser struct {
	// cfg keeps gnparser settings.
	cfg config.Config

	// nameString keeps parsed string
	nameString string

	// parser keeps parsing engine
	parser *grammar.Engine
}

// NewGNparser constructor function takes options and returns
// configured GNparser.
func NewGNparser(cfg config.Config) GNParser {
	gnp := gnparser{cfg: cfg}
	e := &grammar.Engine{Buffer: ""}
	e.Init()
	gnp.parser = e
	return gnp
}

// Parse function parses input string according to configuraions.
// It takes a string and returns an output.Parsed object.
func (gnp gnparser) ParseName(s string) output.Parsed {
	res := output.Parsed{}
	return res
}

// ParseNames function takes input names and returns parsed results.
func (gnp gnparser) ParseNames(names []input.Name) []output.ParseResult {
	var res []output.ParseResult
	return res
}

// Version function returns version number of `gnparser`.
func (gnp gnparser) GetVersion() gn.Version {
	res := gn.Version{
		Version: Version,
		Build:   Build,
	}
	if gnp.cfg.IsTest {
		res.Version = "test_version"
	}
	return res
}
