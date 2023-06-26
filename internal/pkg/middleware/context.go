package middleware

import (
	"github.com/Chever-John/Chever-Apiserver/pkg/log"
	"github.com/gin-gonic/gin"
)

// UsernameKey defines the key in gin context which represents the owner of the secret.
const UsernameKey = "username"

// Context is a middleware that injects common prefix fields to gin.Context.
func Context() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Set(log.KeyRequestID, c.GetString(XRequestIDKey))
		c.Set(log.KeyUsername, c.GetString(UsernameKey))
		c.Next()
	}
}
