package com.aspects.annotations;
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)

/**
 * Used to flag class fields that they need to be thread safe 
 */
public @interface AJLock {

}
