package middleware

import (
	"github.com/gin-gonic/gin"
	gindump "github.com/tpkeeper/gin-dump"
)

// Middlewares store registered middlewares.
var Middlewares = defaultMiddlewares()

func defaultMiddlewares() map[string]gin.HandlerFunc {
	return map[string]gin.HandlerFunc{
		"recovery":  gin.Recovery(),
		"requestid": RequestID(),
		"logger":    Logger(),
		"dump":      gindump.Dump(),
	}
}
