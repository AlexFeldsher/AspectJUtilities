package com.aspects.annotations;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)

/**
 * Annotation used to flag deprecated methods
 */
public @interface AJDeprecatedWarning {

}
