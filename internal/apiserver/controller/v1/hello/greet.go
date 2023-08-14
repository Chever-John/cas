package hello

import (
	"github.com/gin-gonic/gin"

	"github.com/Chever-John/cas/pkg/log"
)

func (hello *HelloerController) Greet(c *gin.Context) {
	log.Info("hello world!")
	c.JSON(200, gin.H{
		"message": "hello world!",
	})
}
