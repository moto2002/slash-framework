﻿// -----------------------------------------------------------------------
// <copyright file="Event.cs" company="Rainy Games">
// Copyright (c) Rainy Games. All rights reserved.
// </copyright>
// -----------------------------------------------------------------------

namespace RainyGames.GameBase
{
    using System;

    /// <summary>
    /// Event that has occurred within the Rainy Games Framework. May contain
    /// additional data listeners might be interested in.
    /// </summary>
    public class Event
    {
        #region Constructors and Destructors

        /// <summary>
        /// Constructs a new event of the specified type.
        /// </summary>
        /// <param name="eventType">
        /// Type of the new event.
        /// </param>
        public Event(object eventType)
            : this(eventType, null)
        {
        }

        /// <summary>
        /// Constructs a new event of the specified type and holding the
        /// passed event data.
        /// </summary>
        /// <param name="eventType">
        /// Type of the new event.
        /// </param>
        /// <param name="eventData">
        /// Data any listener might be interested in.
        /// </param>
        /// <exception cref="ArgumentNullException">
        /// Specified event type is null.
        /// </exception>
        public Event(object eventType, object eventData)
        {
            if (eventType == null)
            {
                throw new ArgumentNullException("eventType");
            }

            this.EventType = eventType;
            this.EventData = eventData;
        }

        #endregion

        #region Properties

        /// <summary>
        /// Type of this event.
        /// </summary>
        public object EventType { get; private set; }

        /// <summary>
        /// Data any listener might be interested in.
        /// </summary>
        public object EventData { get; private set; }

        #endregion
    }
}