package workers

import (
	"context"
	"sync"

	"github.com/anitajordan22244-afk/bodapay/logger"
)

func StartMonitor(ctx context.Context, wg *sync.WaitGroup) {
	wg.Add(1)
	go func() {
		defer wg.Done()
		logger.Log.Info("Monitor worker started")
		<-ctx.Done()
		logger.Log.Info("Monitor worker stopped")
	}()
}
