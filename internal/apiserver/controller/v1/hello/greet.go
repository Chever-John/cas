package hello

import (
	"github.com/Chever-John/cas/pkg/log"
	"github.com/gin-gonic/gin"
)

func (hello *HelloerController) Greet(c *gin.Context) {
	log.Info("hello world!")
	c.JSON(200, gin.H{
		"message": "hello world!",
	})
}
