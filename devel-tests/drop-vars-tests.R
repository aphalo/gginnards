library(ggplot2)
library(gginnards)

mpg

p1 <- ggplot(mpg, aes(class, cty)) +
  geom_boxplot()

p1

p1dp <- drop_vars(p1)

p1dp

p1dpy <- drop_vars(p1, keep.vars = "year")

p1dpy

p1dpyh <- drop_vars(p1, keep.vars = c("year", "hwy"))

p1dpyh

p1dpgv <- drop_vars(p1, keep.vars = c("class", "cty"), guess.vars = FALSE)

p1dpgv

object.size(p1)
object.size(p1dp)
object.size(p1dpy)
object.size(p1dpyh)
object.size(p1dpgv)

names(p1$data)
names(p1dp$data)
names(p1dpy$data)
names(p1dpyh$data)
names(p1dpgv$data)

p2 <- ggplot(mpg, aes(factor(year), cty, colour = class)) +
  geom_boxplot()

p2

p2dp <- drop_vars(p2)

p2dp

object.size(p2)
object.size(p2dp)

names(p2$data)
names(p2dp$data)

p3 <- ggplot(mpg, aes(factor(year), cty)) +
  geom_boxplot() +
  facet_wrap(~ class)

p3

p3dp <- drop_vars(p3)

p3dp

object.size(p3)
object.size(p3dp)

names(p3$data)
names(p3dp$data)

p4 <- ggplot(mpg, aes(factor(year), cty)) +
  geom_boxplot() +
  facet_grid(. ~ class)

p4

p4dp <- drop_vars(p4)

p4dp

object.size(p4)
object.size(p4dp)

names(p4$data)
names(p4dp$data)

p5 <- ggplot(mpg, aes(factor(year), (cty + hwy) / 2)) +
  geom_boxplot() +
  facet_grid(. ~ class)

p5

p5dp <- drop_vars(p5)

p5dp

object.size(p5)
object.size(p5dp)

names(p5$data)
names(p5dp$data)

p6 <- ggplot(mpg) +
  geom_boxplot(mapping = aes(factor(year), (cty + hwy) / 2)) +
  facet_grid(. ~ class)

p6

p6dp <- drop_vars(p6)

p6dp

object.size(p6)
object.size(p6dp)

names(p6$data)
names(p6dp$data)

p7 <- ggplot() %+% mpg +
  geom_boxplot(mapping = aes(factor(year), (cty + hwy) / 2)) +
  facet_grid(. ~ class)

p7

p7dp <- drop_vars(p7)

p7dp

object.size(p7)
object.size(p7dp)

names(p7$data)
names(p7dp$data)

p8 <- ggplot(mpg, aes(factor(year), (cty + hwy) / 2)) +
  geom_boxplot() +
  facet_grid(drv ~ class)

p8

p8dp <- drop_vars(p8)

p8dp

object.size(p8)
object.size(p8dp)

names(p8$data)
names(p8dp$data)
